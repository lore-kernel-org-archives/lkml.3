Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150Ab3DJNYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:24:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34577 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3DJNYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:24:23 -0400
Message-ID: <516567FF.7000802@canonical.com>
Date: Wed, 10 Apr 2013 09:24:15 -0400
From: James M Leddy <james.leddy@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?IkNodW5nLVlpaCBXYW5nICjnjovltIfmh78pIg==?= 
	<cywang@google.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Seth Forshee <seth.forshee@canonical.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, eric.miao@canonical.com,
        daniel.manrique@canonical.com, haitao.zhang@canonical.com
Subject: Re: [PATCH] Input: synaptics - add retry mechanism for reconnect
References: <1361176821-31372-1-git-send-email-cywang@chromium.org> <20130219185026.GB21103@core.coreip.homeip.net> <CAM2ehZYJAkcJ2tVGhi+vOaA5YK9vr7bf6iQETPANLnLqSRN9jg@mail.gmail.com>
In-Reply-To: <CAM2ehZYJAkcJ2tVGhi+vOaA5YK9vr7bf6iQETPANLnLqSRN9jg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll have someone test it out. Thanks for the patch.

On 04/10/2013 01:40 AM, Chung-Yih Wang (王崇懿) wrote:
> Hi Eric Miao, James Leddy and Daniel Manrique,
> 
> If possible, could you give it a try for the patch I have on your device(s)?
> https://patchwork.kernel.org/patch/2156601/
> 
> I think we may address similar issue here. The synaptics device may not
> respond to the commands in synaptics_reconnect() for stress test of
> suspend/resume, so my patch is trying to do 
> the 'retry' for all requests in the reconnect path if one fails.
> 
> 
> 
> On Wed, Feb 20, 2013 at 2:50 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com <mailto:dmitry.torokhov@gmail.com>> wrote:
> 
>     Hi Chung-yih,
> 
>     On Mon, Feb 18, 2013 at 04:40:21PM +0800, Chung-yih Wang wrote:
>     > On the Samsung Series 5 Chromebook, the Synaptics ClickPad will
>     sometimes not
>     > send an "0xFA" PS/2 ACK in response to a command byte during the
>     reconnect
>     > sequence following a resume from suspend. From our experiments,
>     the failure can
>     > happen during any byte of any of the commands in the reconnect batch.
>     >
>     > This failure results in a timeout in the psmouse driver. In
>     addition, the
>     > ClickPad will often also respond to the next PS/2 command byte
>     with an "0xFE"
>     > PS/2 RESEND response.
> 
>     Since you control the firmware of the device can you figure out under
>     what condition the touchpad does not acknowledge the commands sent to it
>     and fix it there?
> 
>     Thanks.
> 
>     --
>     Dmitry
> 
> 

