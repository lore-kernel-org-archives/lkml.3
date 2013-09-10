Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab3IJWkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:40:14 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44963 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751890Ab3IJWkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:40:11 -0400
X-Sasl-enc: +NL+/va+TlRv+6ESxdAyn1Bw9s572bC2W6fhdF5jqMW4 1378852810
Date: Tue, 10 Sep 2013 15:40:09 -0700
From: Greg KH <greg@kroah.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org, akpm@linux-foundation.org,
        zohar@linux.vnet.ibm.com, d.kasatkin@samsung.com,
        ebiederm@xmission.com, hpa@zytor.com, matthew.garrett@nebula.com
Subject: Re: [PATCH 14/16] kexec: Export sysfs attributes for secureboot and
 secure modules to user space
Message-ID: <20130910224009.GA23727@kroah.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
 <1378849471-10521-15-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378849471-10521-15-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 05:44:29PM -0400, Vivek Goyal wrote:
> User space kexec-tools need to know whether to verify signature of kernel
> image being loaded. This patch exports two knobs to user space. One is
> for knowing if  secureboot is enabled, this knob will be set to 1 if secure
> boot is enabled. Other knob is secure_module_enabled. This knob will be set
> to 1 if secure modules is one.
> 
> kexec-tools will verify signature of kernel image if either secureboot is
> enabled or secure modules is enabled. The only difference between two is
> that kexec-tools will set secureboot on in bootparams being passed to
> second kernel if secureboot is on in first kernel.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  kernel/ksysfs.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)

Minor nit, if you add/modify/delete sysfs files, you also have to update
Documentation/ABI/ with the information about those files.

thanks,

greg k-h
