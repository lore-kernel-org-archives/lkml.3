Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaKCPvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:51:39 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39003 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaKCPvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:51:36 -0500
Message-ID: <5457A480.30102@collabora.co.uk>
Date: Mon, 03 Nov 2014 16:51:28 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 05/14] regulator: max1586: zero-initialize regulator
 match table array
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk> <1415025649-8119-6-git-send-email-javier.martinez@collabora.co.uk> <20141103154152.GR3815@sirena.org.uk>
In-Reply-To: <20141103154152.GR3815@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2014 04:41 PM, Mark Brown wrote:
> On Mon, Nov 03, 2014 at 03:40:40PM +0100, Javier Martinez Canillas wrote:
>> The struct of_regulator_match rmatch[] is declared as a non-static local
>> variable so the structure members are not auto-initialized.
> 
> Applied, thanks.
> 
> This is a bug fix not *that* closely related to the rest of the series,
> if it's being included in a series like this it should've been at the
> start of the series not after substantial new feature additions so that
> the fixes don't get ignored due to problems with the features and so
> that the fixes can be sent to Linus without dependencies.
> 

True, I added in the series since of_get_regulation_constraints() checks
if the struct regulator_desc * pointer is not NULL and so drivers that
don't initialize the struct of_regulator_match containing that pointer
will make that check to fail and the pointer be wrongly dereferenced.

Sorry, next time I'll post fixes separately and make the series depend on
that instead.

Best regards,
Javier
