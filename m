Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaBYTYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:24:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbaBYTYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:24:24 -0500
Date: Tue, 25 Feb 2014 13:20:02 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz
Subject: Re: [PATCH 07/11] kexec: Create a relocatable object called purgatory
Message-ID: <20140225182002.GD2701@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-8-git-send-email-vgoyal@redhat.com>
 <530B989B.8010507@zytor.com>
 <20140225164342.GC2701@redhat.com>
 <530CCB0E.3060009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530CCB0E.3060009@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 08:55:42AM -0800, H. Peter Anvin wrote:
> On 02/25/2014 08:43 AM, Vivek Goyal wrote:
> > 
> > W.r.t sharing the code with arch/x86/boot/, I am not sure how to do it.
> > 
> 
> Pretty much we have been doing #includes (a bit sad, I know)... there
> are already a lot of them between arch/x86/boot,
> arch/x86/boot/compressed, and arch/x86/realmode.  In that sense
> collecting these "limited environments" together and have these kinds of
> stuff together in one place seems like a good idea.
> 
> Does purgatory move large amounts of data around?  If so, we probably
> *do* want to use rep movsl, but otherwise you're definitely right, using
> C code makes more sense.

No, I don't move lots of data around in purgatory. We just copy backup
region and that's 640KB of data. 

So we don't copy a lot and it is not a performance sensitive path. 

Hence I would like to keep it simple. That is have C version of memcpy()
in purgatory() which works both for 32bit and 64bit and reuse that across
purgatory code.

Please let me know if you don't like the idea and you still think there
should be a shared implementation between arch/x86/boot/ and
arch/x86/purgatory/.

Thanks
Vivek
