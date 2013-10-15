Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733Ab3JOVdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:33:12 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:56213 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab3JOVdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:33:10 -0400
Message-ID: <525DB456.1040006@cogentembedded.com>
Date: Wed, 16 Oct 2013 01:32:06 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Duncan Laurie <dlaurie@chromium.org>
Subject: Re: [PATCH] usb: hub: Clear Port Reset Change during init/resume
References: <1381872227-24757-1-git-send-email-jwerner@chromium.org>
In-Reply-To: <1381872227-24757-1-git-send-email-jwerner@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/16/2013 01:23 AM, Julius Werner wrote:

> This patch adds the Port Reset Change flag to the set of bits that are
> preemptively cleared on init/resume of a hub. In theory this bit should
> never be set unexpectedly... in practice it can still happen if BIOS,
> SMM or ACPI code plays around with USB devices without cleaning up
> correctly. This is especially dangerous for XHCI root hubs, which don't
> generate any more Port Status Change Events until all change bits are
> cleared, so this is a good precaution to have (similar to how it's
> already done for the Warm Port Reset Change flag).

> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>   drivers/usb/core/hub.c | 5 +++++
>   1 file changed, 5 insertions(+)

> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index e6b682c..c9ef5b8 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -1130,6 +1130,11 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
>   			usb_clear_port_feature(hub->hdev, port1,
>   					USB_PORT_FEAT_C_ENABLE);
>   		}
> +		if ((portchange & USB_PORT_STAT_C_RESET)) {

    Hm, why these double parens?

WBR, Sergei

