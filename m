Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaB0Ssy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:48:54 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:62393 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaB0Sst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:48:49 -0500
MIME-Version: 1.0
In-Reply-To: <1393454916.14900.54.camel@x230>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<1393445473-15068-13-git-send-email-matthew.garrett@nebula.com>
	<20140226224141.1741a746@alan.etchedpixels.co.uk>
	<1393454916.14900.54.camel@x230>
Date: Thu, 27 Feb 2014 10:48:48 -0800
X-Google-Sender-Auth: 5DOxdaQ6FqOSDyuFCuLtrlG_2Co
Message-ID: <CAGXu5j+dwpG=X+i9CY2U3eUsOq86sVhZDRCNoeSYjdDTDv0VbQ@mail.gmail.com>
Subject: Re: [PATCH 12/12] Add option to automatically set trusted_kernel when
 in Secure Boot mode
From: Kees Cook <keescook@chromium.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 2:48 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> On Wed, 2014-02-26 at 22:41 +0000, One Thousand Gnomes wrote:
>> Another issue that needs addressing is firmware. Quite a few of our
>> request_firmware cases load device firmware which is not signed into DMA
>> capable hardware. Probably also worth checking what the
>> architectural guarantees on bogus microcode updates is. Maybe we need
>> firmware signing for such cases to match the mod signing ?
>
> Vendors keep telling me that they're validating firmware for new
> hardware, and I keep tending not to believe them. Meh. The big problem
> with firmware signatures is that we don't necessarily have the right to
> distribute modified versions of the firmware, so we'd need detached
> signature support. I'm certainly not against this.

I have been working on a patch series for this. It will have LSM hooks
for validating firmware origin (via fd) and contents (via blob),
similar to the changes I made for validating module origins. It just
need to finish testing, and I'll post the series. If you want to check
it out in its current state, it's here:

http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=fw-restrict

-Kees

-- 
Kees Cook
Chrome OS Security
