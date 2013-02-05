Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab3BEVzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:55:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:44143 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737Ab3BEVzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:55:11 -0500
MIME-Version: 1.0
In-Reply-To: <20130205183436.GC12853@redhat.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
	<cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
	<20130205181926.GA13942@srcf.ucam.org>
	<20130205183436.GC12853@redhat.com>
Date: Tue, 5 Feb 2013 23:55:09 +0200
Message-ID: <CALLzPKavbsZgHoJrk5iQ0F1fO21SaeEHmCVCh1G1UKCKB3WZZQ@mail.gmail.com>
Subject: Re: [RFC 2/2] initramfs with digital signature protection
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 8:34 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Feb 05, 2013 at 06:19:26PM +0000, Matthew Garrett wrote:
>> On Tue, Feb 05, 2013 at 02:34:50PM +0200, Dmitry Kasatkin wrote:
>>
>> > Digitally signed initramfs can be used to provide protected user-space
>> > environment for initialization purpose. For example, LSM, IMA/EVM can be
>> > securely initialized using such approach.
>>
>> What stops an attacker from simply removing the signed image from the
>> initramfs and running modified versions of the same tools from the
>> unsigned image?
>
> Looks like having signed initramfs image is mandatory otherwise system
> panics.
>
> +       if (sys_access(initramfs_img, 0))
> +               panic("signed initramfs image not found (INITRAMFS_SIG is
> +anabled)\n");
>
> Also I am assuming that from signed initramfs, keys will be loaded in
> appropriate keyrings and then keyring will be locked so that any
> tools from unsigned initramfs can not load additional keys.
>

Exactly like that.


> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
