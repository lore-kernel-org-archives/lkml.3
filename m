Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaG3Itm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:49:42 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58821 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaG3Ith (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:49:37 -0400
Message-ID: <53D8B195.4050003@collabora.co.uk>
Date: Wed, 30 Jul 2014 10:49:25 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 3/5] regulator: core: Only apply constraints if available
 on list voltage
References: <1406651339-28901-1-git-send-email-javier.martinez@collabora.co.uk> <1406651339-28901-4-git-send-email-javier.martinez@collabora.co.uk> <20140729171857.GV17528@sirena.org.uk>
In-Reply-To: <20140729171857.GV17528@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark, thanks a lot for all your feedback.

On 07/29/2014 07:18 PM, Mark Brown wrote:
> On Tue, Jul 29, 2014 at 06:28:57PM +0200, Javier Martinez Canillas wrote:
>> 
>> But for load switches that don't define a voltage output, the parent
>> supply voltage is used so the constraints should only be applied if
>> they were defined for the child regulators.
> 
> No, think about what you're doing here and why we're filtering out
> unsettable voltages - this causes problems for consumers on regulators
> that don't have any ability to vary voltages since they will now be able
> to list voltages that they can't select.  
> 

Understood. Thanks for the explanation.

> I would also expect any regulator where the supplied devices are able to
> vary the voltage to explicitly provide a constraint even if the
> implementation is done in a parent regulator.  There may be constraints
> on the child supply which aren't directly present on the parent supply
> and can be ignored if the child supply is turned off.
> 

Agreed, if I explicitly set the voltage constraints on the child supply then
this patch is indeed not needed.

Best regards,
Javier
