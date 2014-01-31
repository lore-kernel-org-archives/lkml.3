Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbaAaP0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:26:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55148 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbaAaP0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:26:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pratyush Anand <pratyush.anand@st.com>
Subject: Re: [PATCH V3 4/8] phy: Initialize phy core with subsys_initcall
Date: Fri, 31 Jan 2014 16:25:53 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        "spear-devel" <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <cover.1391077731.git.mohit.kumar@st.com> <201401301344.59196.arnd@arndb.de> <20140131034803.GA2618@pratyush-vbox>
In-Reply-To: <20140131034803.GA2618@pratyush-vbox>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401311625.53846.arnd@arndb.de>
X-Provags-ID: V02:K0:tvZhaFRVrto70hRZbWbMzpYgz3kfiqUS+dk7l55KzuF
 SN/zRfsZpujuYBcy3apCH0aIoU9IC1BiEzFzbANEhnnXvcnycd
 nURqQs6dNy3sUR7p2KSaxYYV0yFBFZpTgDv0pQr1fBLxNmjTMC
 uCymlc+GQN780FVd3HjEwm2ULVhqNI4X7T3b7pEmtlNEe2YoDe
 LxvN9e3fpTuEKTotbAlizBD9tdyCqZa3HTMCMvJ/hljkLaxcfY
 3/bF9SMEbwA4exJ4Sq4eLtLbzT0BqjLY5Jlxu59f+49psanqOA
 uHtTcTk96LMU5uT12p29CCP7Er1hE52Dz6bfF5D7Gjkyjfic2k
 wyhzYcHvVUHydIm7Y8oEQq+loqVNfTfg9Ur5YmHxv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 January 2014, Pratyush Anand wrote:
> > Having the PHY driver get initialized after the PCI root driver should
> > also work, but it requires correct handling of -EPROBE_DEFER: if phy_get
> 
> I had issue with phy-core driver getting initialized after pcie rc
> driver. I found a kernel crash, as devm_phy_get was called before
> phy_class was created. I think this too need to be fixed, we should
> not see a crash.

Yes, agreed. This should be trivial to do though.

> Anyway, I will keep spear phy and rc driver both with module_init and
> -EPROBE_DEFER implementation.

Ok.

	Arnd
