Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbaFPU54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:57:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35050 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbaFPU5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:57:55 -0400
Date: Mon, 16 Jun 2014 22:57:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/13] kexec-bzImage: Support for loading bzImage using
 64bit entry
Message-ID: <20140616205743.GI8170@pd.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-12-git-send-email-vgoyal@redhat.com>
 <20140615163515.GA17016@pd.tnic>
 <20140616200608.GD4515@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140616200608.GD4515@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 04:06:08PM -0400, Vivek Goyal wrote:
> There can be more than one loader and the one which claims first
> to recognize the image will get to load the image. So once 32 bit
> loader support comes in, it might happen that we ask 64bit loader
> first and it rejects the image and then we ask 32bit loader.

What does that have to do with anything??

> So these message are really debug message which tells why loader
> is not accepting an image. It might not be image destined for that
> loader at all.
> 
> pr_debug() allows being verbose if user wants to for debugging purposes.
> You just have to make sure that CONFIG_DYNAMIC_DEBUG=y and enable verbosity
> in individual file.
> 
> echo 'file kexec-bzimage.c +p' > /sys/kernel/debug/dynamic_debug/control

So people are supposed to enable dynamic_debug just so that they see
*why* their image doesn't load.

Doesn't sound optimal to me.

> Same here. We will potentially be trying multiple loaders and if every
> loader prints messages for rejection by default, it is too much of
> info, IMO.

For max two loaders on one architecture? I don't think so. Now you're
just arguing for the sake of it.

> I like doing memory allocations early in the functions (as far as
> possible) and error out if need be. If memory is available to begin
> with for all the data structures needed by this function, it is kind
> of pointless to do rest of the processing.

We're talking about memory for a single void * which is ridiculous. And
I think simplifying the error paths is a much higher win than doing some
minor allocation.

> Hmm..., If you feel strongly about it, I can make this change. I
> thought I just made it easier to share the code between 32bit and
> 64bit by this.

Someone later can do that - right now this code is 64-bit only as far as
we're concerned and if it can be made to work on 32-bit, then people are
free to do so.

> I think it just makes it safer that we don't try to copy more than
> size of destination, in case ->eddbuf_entries is not right or corrupted.
> 
> I see copy_edd() does similar thing.
> 
> memcpy(edd.edd_info, boot_params.eddbuf, sizeof(edd.edd_info));
> edd.edd_info_nr = boot_params.eddbuf_entries;
> 
> So may be it is not a bad idea to copy based on max size of data
> structures.

Ok, makes sense.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
