Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaHZP5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:57:14 -0400
Received: from smtp-out-167.synserver.de ([212.40.185.167]:1049 "EHLO
	smtp-out-167.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaHZP5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:57:13 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7282
Message-ID: <53FCAE57.2050103@metafoo.de>
Date: Tue, 26 Aug 2014 17:57:11 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Scott Jiang <scott.jiang.linux@gmail.com>
CC: linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] regmap: Fix handling of volatile registers for format_write()
 chips
References: <1409052255-10601-1-git-send-email-broonie@kernel.org>
In-Reply-To: <1409052255-10601-1-git-send-email-broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 01:24 PM, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
>
> A previous over-zealous factorisation of code means that we only treat
> registers as volatile if they are readable. For most devices this is fine
> since normally most registers can be read and volatility implies
> readability but for format_write() devices where there is no readback from
> the hardware and we use volatility to mean simply uncacheability this means
> that we end up treating all registers as cacheble.
>
> A bigger refactoring of the code to clarify this is in order but as a fix
> make a minimal change and only check readability when checking volatility
> if there is no format_write() operation defined for the device.
>
> Signed-off-by: Mark Brown <broonie@linaro.org>

Tested-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks.
