Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbaIVOad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:30:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbaIVOac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:30:32 -0400
Message-ID: <1411396206.25340.49.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64/pci: fix dma coherency inheritance for PCI devices
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jcm@redhat.com" <jcm@redhat.com>
Date: Mon, 22 Sep 2014 10:30:06 -0400
In-Reply-To: <20140922102352.GH30085@e104818-lin.cambridge.arm.com>
References: <1411141886-11310-1-git-send-email-msalter@redhat.com>
	 <20140922102352.GH30085@e104818-lin.cambridge.arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-22 at 11:23 +0100, Catalin Marinas wrote:
> >  static int __init swiotlb_late_init(void)
> > @@ -341,6 +357,7 @@ static int __init swiotlb_late_init(void)
> >        */
> >       bus_register_notifier(&platform_bus_type, &platform_bus_nb);
> >       bus_register_notifier(&amba_bustype, &amba_bus_nb);
> > +     bus_register_notifier(&pci_bus_type, &pci_bus_nb);
> 
> Does this compile when CONFIG_PCI is disabled?

No. Doh!



