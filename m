Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3EaNFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 09:05:19 -0400
Received: from muin.pair.com ([209.68.1.55]:57181 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab3EaNFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 09:05:15 -0400
Message-ID: <51A8A016.3000306@tabi.org>
Date: Fri, 31 May 2013 08:05:26 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v3 1/8] video: xilinxfb: Fix OF probing on little-endian
 systems
References: <cover.1370004925.git.michal.simek@xilinx.com> <0a546c3de84c4650d019274debef0ded9007b36f.1370004925.git.michal.simek@xilinx.com>
In-Reply-To: <0a546c3de84c4650d019274debef0ded9007b36f.1370004925.git.michal.simek@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 07:55 AM, Michal Simek wrote:
> -	p = (u32 *)of_get_property(op->dev.of_node, "xlnx,dcr-splb-slave-if", NULL);
> -	tft_access = p ? *p : 0;
> +	of_property_read_u32(op->dev.of_node, "xlnx,dcr-splb-slave-if",
> +			     &tft_access);

This is okay, but just FYI, you could instead have just used be32_to_cpup().

-- 
Timur Tabi
