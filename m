Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaLQWRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 17:17:24 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:57105 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaLQWRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 17:17:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Minghuan Lian <Minghuan.Lian@freescale.com>,
        Magnus Damm <damm@opensource.se>, Will Deacon <will.deacon@arm.com>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Sachin Kamat <sachin.kamat@samsung.com>, Andrew Lunn <andrew@lunn.ch>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Srikanth Thokala <sthokal@xilinx.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, linux-pci@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 4/5] PCI: designware: Add setup bus-related to pcie_host_ops
Date: Wed, 17 Dec 2014 23:16:12 +0100
Message-ID: <1507589.aeTeyNn1QF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418812486-12394-5-git-send-email-gabriel.fernandez@linaro.org>
References: <1418812486-12394-1-git-send-email-gabriel.fernandez@linaro.org> <1418812486-12394-5-git-send-email-gabriel.fernandez@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:oQnNhGGD0Ig9DUf1diHKsH4dUV6+DV90wC4b23UKW//P7zWuBqP
 +2emUigzrhsv5louyVWKNqOWQA45egHHeJJzG3ETkQDmY5wQuxmfpUw0e9Jm75ZeZGdOSnw
 yZ2mx0ECeY7vIRQmNlAUL3KGHi3MO0XBLj601OAZ0rn2JCCnebFOvj/jpu7VoiS0b8FgurN
 uJkd7yNqPEWxhkdZq/tHQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 December 2014 11:34:45 Gabriel FERNANDEZ wrote:
> ST sti SoCs PCIe IPs are built around DesignWare IP Core.
> But in these SoCs PCIe IP doesn't support IO.
> 
> To support this, add setup_bus() to pcie_host_ops.
> 
> Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>

The dw-pcie driver should be able to tell whether the device has
an I/O space or not, and do the right thing based on that. Don't
add an implementation specific callback for that.

	Arnd
