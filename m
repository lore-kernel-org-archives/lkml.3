Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab3JAUAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:00:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56926 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3JAUAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:00:50 -0400
Message-ID: <524B29EE.4090608@wwwdotorg.org>
Date: Tue, 01 Oct 2013 14:00:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rhyland Klein <rklein@nvidia.com>
CC: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Manish Badarkhe <badarkhe.manish@gmail.com>,
        Darbha Sriharsha <dsriharsha@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [Patch V4] drivers: power: Add support for bq24735 charger
References: <1380211376-7539-1-git-send-email-rklein@nvidia.com>
In-Reply-To: <1380211376-7539-1-git-send-email-rklein@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 10:02 AM, Rhyland Klein wrote:
> From: Darbha Sriharsha <dsriharsha@nvidia.com>
> 
> Adds support for the bq24735 charger chipset. The bq24735 is a
> high-efficiency, synchronous battery charger.
> 
> It allows control of the charging current, input current, and the charger
> voltage DAC's through SMBus.

> diff --git a/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt b/Documentation/devicetree/bindings/power_supply/ti,bq24735.txt

> +Optional properties :

> + - ti,charge-current : Used to control and set the charging current. This value
> +   must be between 128mA and 8.128A with a 64mA step resolution. The POR value
> +   is 0x0000h. See spec for more details.
> + - ti,charge-voltage : Used to control and set the charging voltage. This value
> +   must be between 1.024V and 19.2V with a 16mV step resolution. The POR value
> +   is 0x0000h. See spec for more details.
> + - ti,input-current : Used to control and set the charger input current. This
> +   value must be between 128mA and 8.064A with a 128mA step resolution. The
> +   POR value is 0x1000h. See spec for more details.

What units and representation do those properties use? I assume it's mA
and mV, without any shift or register encoding, but the text doesn't
make it clear. It'd be best to reference a specific register name rather
than just saying "see the spec".
