Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaB0TLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:11:09 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:35501 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaB0TLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:11:07 -0500
MIME-Version: 1.0
In-Reply-To: <20140227190710.GA4755@kroah.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	<20140227190710.GA4755@kroah.com>
Date: Thu, 27 Feb 2014 14:11:07 -0500
X-Google-Sender-Auth: xD46IXPiUIkI3qwcBK4qa14S4Jg
Message-ID: <CA+5PVA4GNWFx5bDM912TYmDbMHmZpb2X=Tzo85mGEGATvbW70A@mail.gmail.com>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 2:07 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Feb 27, 2014 at 01:04:34PM -0500, Josh Boyer wrote:
>> On Wed, Feb 26, 2014 at 3:11 PM, Matthew Garrett
>> <matthew.garrett@nebula.com> wrote:
>> > The conclusion we came to at Plumbers was that this patchset was basically
>> > fine but that Linus hated the name "securelevel" more than I hate pickled
>> > herring, so after thinking about this for a few months I've come up with
>> > "Trusted Kernel". This flag indicates that the kernel is, via some
>> > external mechanism, trusted and should behave that way. If firmware has
>> > some way to verify the kernel, it can pass that information on. If userspace
>> > has some way to verify the kernel, it can set the flag itself. However,
>> > userspace should not attempt to use the flag as a means to verify that the
>> > kernel was trusted - untrusted userspace could have set it on an untrusted
>> > kernel, but by the same metric an untrusted kernel could just set it itself.
>>
>> FWIW, I've been running a kernel using this patchset in place of the
>> patchset Fedora typically carries for this purpose for a bit.  Things
>> appear to be working as expected and the protections remain the same.
>>
>> It would be really nice to get this set of patches in so some of the
>> other patches that depend on them can start being pushed as well.
>
> What other patches depend on this series?  Why aren't they also in this
> series?

The patches we have to import certificates from the UEFI db and dbx
vars, and MokListRT and apply them to signed module verification.
Looking at them closely, there are pieces that could be sent now as
they are slightly orthogonal to what this patchset is doing, which is
probably why they aren't in this patchset to begin with.  I'll have to
figure out which of those actually depend on anything in Matthew's
series.

josh
