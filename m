Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab3HSWbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 18:31:48 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:40208 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab3HSWbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 18:31:46 -0400
Message-ID: <52129CD4.1060200@cogentembedded.com>
Date: Tue, 20 Aug 2013 02:31:48 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
CC: Jan Dumon <j.dumon@option.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix stack corruption on some architectures
References: <1376944647.5082.12.camel@chimera>
In-Reply-To: <1376944647.5082.12.camel@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/20/2013 12:37 AM, Daniel Gimpelevich wrote:

> There is no need to get an interface specification if we know it's the
> wrong one; trivial change.

    Is it related to stack corruption? If not, it's asking to be in a separate 
patch.

> The big thing, though, was explained in the
> #mipslinux IRC channel:
> [Mon 2013-08-19 12:28:21 PM PDT] <headless> guys, are you sure it's not "DMA off stack" case?
> [Mon 2013-08-19 12:28:35 PM PDT] <headless> it's a known stack corruptor on non-coherent arches
> [Mon 2013-08-19 12:31:48 PM PDT] <DonkeyHotei> headless: for usb/ehci?
> [Mon 2013-08-19 12:34:11 PM PDT] <DonkeyHotei> headless: explain
> [Mon 2013-08-19 12:35:38 PM PDT] <headless> usb_control_msg() (or other such func) should not use buffer on stack. DMA from/to stack is prohibited
> [Mon 2013-08-19 12:35:58 PM PDT] <headless> and EHCI uses DMA on control xfers (as well as all the others)

    That headless was me. :-)

> Signed-off-by: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>

WBR, Sergei

