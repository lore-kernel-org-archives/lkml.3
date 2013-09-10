Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3IJPLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:11:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54269 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab3IJPLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:11:18 -0400
Message-ID: <522F3691.3090805@wwwdotorg.org>
Date: Tue, 10 Sep 2013 09:11:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@kernel.org, rob.herring@calxeda.com, mark.rutland@arm.com,
        rob@landley.net, devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Subject: Re: [PATCH 2/2] regulator: core: add support for configuring turn-on
 time through constraints
References: <1378811888-2268-1-git-send-email-ldewangan@nvidia.com> <1378811888-2268-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1378811888-2268-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 05:18 AM, Laxman Dewangan wrote:
> The Turn-ON time of the regulator depends on the regulator device's
> electrical characteristics. Sometimes regulator turn-on time also
> depends on the capacitive load on the given platform and it can be
> more than the datasheet value.
> 
> The driver provides the enable-time as per datasheet.
> 
> Add support for configure the enable time through regulator constraints
> so that regulator core can take this value for enable time for that
> regulator.

> diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt

> +- regulator-enable-time: Turn ON time for regulator(in uS)

Bike-shedding slightly: This isn't really the time it takes to enable a
regulator, but the time the voltage takes to become stable, or settle.
Perhaps name the property regulator-settle-time/regulator-settle-delay?
