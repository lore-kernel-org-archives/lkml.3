Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaJVGC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:02:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaJVGC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:02:26 -0400
Date: Wed, 22 Oct 2014 08:02:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Seth Jennings <sjenning@redhat.com>
Subject: Re: [PATCH] kprobes: add kprobe_is_function_probed()
In-Reply-To: <544716CA.2020605@hitachi.com>
Message-ID: <alpine.LNX.2.00.1410220800040.22681@pobox.suse.cz>
References: <alpine.LNX.2.00.1410211744550.24255@pobox.suse.cz> <544716CA.2020605@hitachi.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014, Masami Hiramatsu wrote:

> > Add a function that allows external users (such as live patching 
> > mechanisms) to check whether a given function (identified by symbol name) 
> > has a kprobe installed in it.
> 
> Actually, we've already exported the list of kprobes with probe points
> (symbols) via debugfs. Please check /sys/kernel/debug/kprobes/list :)

Yes, I know, and kprobe_is_function_probed() is performing very similar 
thing that show_kprobe_addr() is doing.
But we'd like to be able to check this from within a kernel module (the 
patch module) and issue WARN().

Otherwise we'll need to have a machinery in userspace before insmod which 
will look up the functions in the module and compare them to the 
debufs-provided interface.

Also, I don't think we want to be dependent on debugfs being mounted and 
discoverable, etc ...

Thanks Masami,

-- 
Jiri Kosina
SUSE Labs
