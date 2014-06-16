Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbaFPV1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:27:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50384 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaFPV1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:27:31 -0400
Date: Mon, 16 Jun 2014 23:27:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/13] kexec-bzImage: Support for loading bzImage using
 64bit entry
Message-ID: <20140616212720.GL8170@pd.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-12-git-send-email-vgoyal@redhat.com>
 <20140615163515.GA17016@pd.tnic>
 <20140616200608.GD4515@redhat.com>
 <20140616205743.GI8170@pd.tnic>
 <20140616211500.GA1870@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140616211500.GA1870@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 05:15:00PM -0400, Vivek Goyal wrote:
> Do we want to show all the rejection messages from bzImage64 and
> bzImage32 loaders. It might be too verbose to show users that before
> vmlinux loader accepted the image other loaders on this arches rejcted
> the image.

I get all that. But, if people want to get feedback from the system
about *why* their image didn't load, they absolutely have to enable
dynamic debug. And this is not optimal IMO because they will have to
look at the code first to see what they need to do.

Or is kexec-tools going to be taught to interpret return values from the
syscall?

In any case, we want information about why an image fails loading to
reach the user in the easiest way possible. And why should the user need
to enable dynamic debug if he can get the info without doing so?

Oh, and not everyone knows about dynamic debug so...

And I don't think it'll be too much info - only the line which fails
the check will be printed before the image loader fails so that's
practically one error reason per failed image.

Ok?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
