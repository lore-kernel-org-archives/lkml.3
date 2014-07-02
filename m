Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbaGBXUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 19:20:52 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:52965 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaGBXUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 19:20:50 -0400
Date: Wed, 2 Jul 2014 16:20:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Luiz Capitulino <lcapitulino@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org, riel@redhat.com,
        andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [PATCH] x86: numa: setup_node_data(): drop dead code and rename
 function
In-Reply-To: <20140702133358.0b4262cd@redhat.com>
Message-ID: <alpine.DEB.2.02.1407021615550.5931@chino.kir.corp.google.com>
References: <20140619222019.3db6ad7e@redhat.com> <alpine.DEB.2.02.1406301639390.1327@chino.kir.corp.google.com> <20140702133358.0b4262cd@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014, Luiz Capitulino wrote:

> > With this patch, the dmesg changes break one of my scripts that we use to 
> > determine the start and end address of a node (doubly bad because there's 
> > no sysfs interface to determine this otherwise and we have to do this at 
> > boot to acquire the system topology).
> > 
> > Specifically, the removal of the
> > 
> > 	"Initmem setup node X [mem 0xstart-0xend]"
> > 
> > lines that are replaced when each node is onlined to
> > 
> > 	"Node 0 memory range 0xstart-0xend"
> > 
> > And if I just noticed this breakage when booting the latest -mm kernel, 
> > I'm assuming I'm not the only person who is going to run into it.  Is it 
> > possible to not change the dmesg output?
> 
> Sure. I can add back the original text. The only detail is that with this
> patch that line is now printed a little bit later during boot and the
> NODA_DATA lines also changed. Are you OK with that?
> 

Yes, please.  I think it should be incremental on your patch since it's 
already in -mm with " fix" appended so the title of the patch would be 
"x86: numa: setup_node_data(): drop dead code and rename function fix" and 
then Andrew can fold it into the original when sending it to the x86 
maintainers.

> What's the guidelines on changing what's printed in dmesg?
> 

That's the scary part, there doesn't seem to be any.  It's especially 
crucial for things that only get printed once and aren't available 
anywhere else at runtime; there was talk of adding a sysfs interface that 
defines the start and end addresses of nodes but it's complicated because 
nodes can overlap each other.  If that had been available years ago then I 
don't think anybody would raise their hand about this issue.

These lines went under a smaller change a few years ago for 
s/Bootmem/Initmem/.  I don't even have to look at the git history to know 
that because it broke our scripts back then as well.  You just happened to 
touch lines that I really care about and breaks my topology information :)  
I wouldn't complain if it was just my userspace, but I have no doubt 
others have parsed their dmesg in a similar way because people have 
provided me with data that they retrieved by scraping the kernel log.
