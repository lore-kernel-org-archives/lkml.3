Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936019Ab3DHUSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:18:00 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:52078 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935904Ab3DHUR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:17:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130408200904.GI28292@redhat.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
	<cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
	<20130205181926.GA13942@srcf.ucam.org>
	<20130205183436.GC12853@redhat.com>
	<CALLzPKavbsZgHoJrk5iQ0F1fO21SaeEHmCVCh1G1UKCKB3WZZQ@mail.gmail.com>
	<20130405135000.GB6299@redhat.com>
	<1365450229.3847.56.camel@falcor1.watson.ibm.com>
	<20130408200904.GI28292@redhat.com>
Date: Mon, 8 Apr 2013 16:17:56 -0400
Message-ID: <CA+5PVA43U_kDSV7p0zhQwmK9pwbVb8qAUePU8svQvoPbDA9iCQ@mail.gmail.com>
Subject: Re: [RFC 2/2] initramfs with digital signature protection
From: Josh Boyer <jwboyer@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 8, 2013 at 4:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Apr 08, 2013 at 03:43:49PM -0400, Mimi Zohar wrote:
>> On Fri, 2013-04-05 at 09:50 -0400, Vivek Goyal wrote:
>> > On Tue, Feb 05, 2013 at 11:55:09PM +0200, Kasatkin, Dmitry wrote:
>> >
>> > [..]
>> > > > Also I am assuming that from signed initramfs, keys will be loaded in
>> > > > appropriate keyrings and then keyring will be locked so that any
>> > > > tools from unsigned initramfs can not load additional keys.
>> > > >
>> > >
>> > > Exactly like that.
>> >
>> > Dmitry,
>> >
>> > [ Following up on this thread after a very long time ]
>> >
>> > I was thinking about this point that keys can be loaded from signed
>> > initramfs. But how is it better than embedding the keys in kernel the
>> > way we do for module signing and lock down ima keyring before control
>> > is passed to initramfs.
>> >
>> > Reason being, that anyway a user can not put its own keys in signed
>> > initramfs. Signed initramfs will be shipped by distribution. So then
>> > it does not matter whether distribution's keys are embedded in the
>> > kernel or are loaded from signed initramfs.
>>
>> Although both the early initramfs and the kernel are signed, building
>> the keys into the kernel implies a static set of predefined public keys,
>> while the initramfs could load, in addition to the distro keys, keys
>> from the UEFI databases.
>
> Kernel already loads all the keys from UEFI database and MOK into module
> keyring.

Small point of order: there are patches to allow the kernel to do this.
None of those patches are upstream.

josh
