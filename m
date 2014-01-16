Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaAPKro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:47:44 -0500
Received: from smtp.citrix.com ([66.165.176.89]:33126 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbaAPKrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:47:39 -0500
X-IronPort-AV: E=Sophos;i="4.95,667,1384300800"; 
   d="scan'208";a="93414668"
Message-ID: <52D7B8C8.9010301@citrix.com>
Date: Thu, 16 Jan 2014 10:47:36 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>, Richard Weinberger <richard@nod.at>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v2] drivers/tty/hvc: don't use module_init in non-modular
 hyp. console code
References: <1389821743-25081-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1389821743-25081-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/14 21:35, Paul Gortmaker wrote:
> The HVC_OPAL/RTAS/UDBG/XEN options are all bool, and hence their support
> is either present or absent.  It will never be modular, so using
> module_init as an alias for __initcall is rather misleading.
> 
> Fix this up now, so that we can relocate module_init from
> init.h into module.h in the future.  If we don't do this, we'd
> have to add module.h to obviously non-modular code, and that
> would be a worse thing.
> 
> Note that direct use of __initcall is discouraged, vs. one
> of the priority categorized subgroups.  As __initcall gets
> mapped onto device_initcall, our use of device_initcall
> directly in this change means that the runtime impact is
> zero -- it will remain at level 6 in initcall ordering.
> 
> Also the __exitcall functions have been outright deleted since
> they are only ever of interest to UML, and UML will never be
> using any of this code.

For the hvc_xen changes

Acked-by: David Vrabel <david.vrabel@citrix.com>

Thanks

David
