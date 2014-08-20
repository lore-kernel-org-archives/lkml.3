Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaHTL2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:28:37 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49382 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaHTL2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:28:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH] drivers: pci: convert generic host controller to DT host bridge creation API
Date: Wed, 20 Aug 2014 13:27:57 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        "linux-pci" <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
References: <1407861695-25549-1-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1407861695-25549-1-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201408201327.57376.arnd@arndb.de>
X-Provags-ID: V02:K0:ubYGfXKxpVTTh0kYIKfMxehpIl/nR+Yc36ZtD+4yPmC
 kJjZlpgDA5cUXJnJW8fRMNwaK4X2BscV2c4nc0G3M/a1NFiteU
 07FimL1a+H7GvL0Uounbac11pjNSrBrciKx46IZ+B0kOxXQsRC
 C3BwR42Td01L9o8JdOwWp2ORb3eJaKxP58yckonVhZJ/s+GSC2
 4Y2mhGyz/Gd8zBd5IAEvTwf6xHWo77vV+UI43hBWdhQQ8sKICE
 LFQOQmIDxjNLgjhcpIm16b98nMFHSJIC2bJHxCaHsGNO7tEZ7X
 tx0orFAbW7temPYYhjBhbEALy4TgUgBmLV9DhwfK2VD9vhUj+A
 Ui6elKav5X2k4TgqcnM0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 August 2014, Liviu Dudau wrote:
> +       return of_create_pci_host_bridge(dev, 0, 0xff, &gen_pci_ops,
> +                                       gen_pci_setup, pci);

I had not noticed it earlier, but the setup callback is actually a feature
of the arm32 PCI code that I had hoped to avoid when moving to the
generic API. Can we do this as a more regular sequence of


	ret = of_create_pci_host_bridge(dev, 0, 0xff, &gen_pci_ops, pci);
	if (ret)
		return ret;

	ret = gen_pci_setup(pci);
	if (ret)
		pci_destroy_host_bridge(dev, pci);
	return ret;

?

	Arnd
