Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaESIkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:40:36 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:58987 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbaESIk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:40:27 -0400
Date: Mon, 19 May 2014 12:40:22 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: mm: NULL ptr deref handling mmaping of special mappings
Message-ID: <20140519084022.GC2185@moon>
References: <5373D509.7090207@oracle.com>
 <20140514140305.7683c1c2f1e4fb0a63085a2a@linux-foundation.org>
 <5373DBE4.6030907@oracle.com>
 <20140514143124.52c598a2ba8e2539ee76558c@linux-foundation.org>
 <CALCETrXQOPBOBOgE_snjdmJM7zi34Ei8-MUA-U-YVrwubz4sOQ@mail.gmail.com>
 <20140514221140.GF28328@moon>
 <CALCETrUc2CpTEeo=NjLGxXQWHn-HG3uYUo-L3aOU-yVjVx3PGg@mail.gmail.com>
 <5374281F.6020807@parallels.com>
 <CALCETrWw7tS2Lpnb1OxgZpBwHvOSbDk2zBVtUTJEp5eooYUyhA@mail.gmail.com>
 <5379C071.4090100@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5379C071.4090100@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 12:27:29PM +0400, Pavel Emelyanov wrote:
> > 
> > What happens if you try to checkpoint a program that's in the vdso or,
> > worse, in a signal frame with the vdso on the stack?
> 
> Nothing good, unfortunately :( And this is one of the things we're investigating.
> Cyrill can shed more light on it, as he's the one in charge.

vdso on stack should not be a big deal, because we keep original vdso proxy.
