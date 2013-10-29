Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3J2TSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:18:08 -0400
Received: from smtp-out-046.synserver.de ([212.40.185.46]:1051 "EHLO
	smtp-out-046.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3J2TSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:18:06 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13024
Message-ID: <527009EB.3010704@metafoo.de>
Date: Tue, 29 Oct 2013 20:18:03 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Josh Cartwright <joshc@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: Re: [PATCH v3 02/10] spmi: Linux driver framework for SPMI
References: <cover.1382985169.git.joshc@codeaurora.org> <149bbfe89e37376cc176c3aeb6c1fab9e4fd2b91.1382985169.git.joshc@codeaurora.org> <526FD278.8080102@metafoo.de> <20131029155616.GG20207@joshc.qualcomm.com> <526FE2B6.8050701@codeaurora.org>
In-Reply-To: <526FE2B6.8050701@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 05:30 PM, Stephen Boyd wrote:
> On 10/29/13 08:56, Josh Cartwright wrote:
>>
>>>> +#define to_spmi_controller(d) container_of(d, struct spmi_controller, dev)
>>> Should be a inline function for better type safety.
>> Sounds good.  Will change the to_spmi_*() macros.
> 
> I was under the impression that container_of() already does type
> checking. At least it will ensure that typeof(d) == typeof(dev) in the
> above example which is about as good as it can get.

Well you'll get a warning, but the quality of the warning message is much
better when an inline function is used.

warning: initialization from incompatible pointer type

vs.

warning: Passing argument 1 of to_smpi_controller() from incompatible
pointer type. Expected struct device * got struct driver *


- Lars
