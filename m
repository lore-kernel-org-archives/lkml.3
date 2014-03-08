Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaCHRSF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 12:18:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:52066 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbaCHRSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 12:18:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v6 2/6] pci: OF: Fix the conversion of IO ranges into IO resources.
Date: Sat, 8 Mar 2014 18:17:39 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-pci" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>
References: <1394020137-1830-1-git-send-email-Liviu.Dudau@arm.com> <1394020137-1830-3-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1394020137-1830-3-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201403081817.39810.arnd@arndb.de>
X-Provags-ID: V02:K0:fA3fhnTGXqBHlF0pGeFW6hSKlDDYYe1ijm6optHCNj8
 Ha5GjhHgQdGz0ArVJAYjpD9FEo63rI4LUBIrrRa0tHj7MY/Him
 Czm2FW2rxFAPY+PTKIZg9C3v7lcqXq5Y52igQjNcQLIxKL8+v9
 ndpXHz0OPKMRRwfDKTetJmZ2V0IaRQySndRVOi/sXfiwhyohhv
 0wc6DhWEAZXUb59ZKDzqsZ6JFgiL+se7/HeBdeKD+euxcAEOCU
 OpyYFtyyPOHMMV+hqPd4r2EkICnW8m9sgMYiQY+66ix24ySikP
 hYpEzg5tzyIW+wjRDEGTPiicZPxpjzQdT8b8c6nYH7ABoDnCWf
 5d9EpXCTwr2xXfydOPW8ISdfGIWy1sAU6PoJKlGCq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 March 2014, Liviu Dudau wrote:
> +               unsigned long port = -1;
> +               if (!pci_register_io_range(range->cpu_addr, range->size))
> +                       port = pci_address_to_pio(range->cpu_addr);

I don't remember the outcome of my suggestion to just return 'port' from
pci_register_io_range(). In my mind that would be much simpler than
adding the range in a data structure just so we can look it up in the very
next line.

	Arnd
