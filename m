Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3KKCW7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 21:22:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35458 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab3KKCWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 21:22:50 -0500
Message-ID: <52803F15.3080204@zytor.com>
Date: Sun, 10 Nov 2013 18:21:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>
CC: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, Greg KH <greg@kroah.com>
Subject: Re: [patch 0/7 v2] kexec kernel efi runtime support
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com> <20131108143118.GA22636@console-pimps.org> <20131109035739.GB4294@dhcp-16-126.nay.redhat.com> <527DC1BE.6030107@zytor.com> <20131111021356.GC4407@dhcp-16-126.nay.redhat.com>
In-Reply-To: <20131111021356.GC4407@dhcp-16-126.nay.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2013 06:13 PM, Dave Young wrote:
> 
> Huang Ying <ying.huang@intel.com> created the debugfs file for boot_params.
> His first version patch tried sysfs, but sysfs is not designed for such
> binary blobs so finally it go to debugfs.
> 

That is a misunderstanding.  Binary blobs can exist in sysfs as long as
the blob is something that is inherently a blob.  This is admittedly a
corner case, but it is without any doubt a protocol-defined binary
structure.

The reason it was put in debugfs is that there was no non-debug user for
it at the time.

> Any idea for this is welcome, till now I have no better idea for such kind
> of data. We should have another *fs instead of using debugfs.

The problem with debugfs is that things go into debugfs with largely no
auditing.  As a result, mounting debugfs is very likely to mean that
your system is exploitable one way or another.

	-hpa


