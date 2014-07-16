Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaGPJkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 05:40:25 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46395 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaGPJkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 05:40:22 -0400
Message-ID: <53C64883.2050709@arm.com>
Date: Wed, 16 Jul 2014 10:40:19 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jassi Brar <jaswinder.singh@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "courtney.cavin@sonymobile.com" <courtney.cavin@sonymobile.com>,
        "mporter@linaro.org" <mporter@linaro.org>,
        "slapdau@yahoo.com.au" <slapdau@yahoo.com.au>,
        "lftan.linux@gmail.com" <lftan.linux@gmail.com>,
        "loic.pallardy@st.com" <loic.pallardy@st.com>,
        "s-anna@ti.com" <s-anna@ti.com>,
        "ashwin.chaugule@linaro.org" <ashwin.chaugule@linaro.org>,
        "bjorn@kryo.se" <bjorn@kryo.se>,
        "patches@linaro.org" <patches@linaro.org>,
        "Mollie.Wu@tw.fujitsu.com" <Mollie.Wu@tw.fujitsu.com>,
        "t.takinishi@jp.fujitsu.com" <t.takinishi@jp.fujitsu.com>
Subject: Re: [PATCHv8 2/2] mailbox: Introduce framework for mailbox
References: <1405071167-14503-1-git-send-email-jaswinder.singh@linaro.org> <1405071325-14683-1-git-send-email-jaswinder.singh@linaro.org>
In-Reply-To: <1405071325-14683-1-git-send-email-jaswinder.singh@linaro.org>
X-OriginalArrivalTime: 16 Jul 2014 09:40:18.0519 (UTC) FILETIME=[F45E1E70:01CFA0D9]
X-MC-Unique: 114071610401918101
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/07/14 10:35, Jassi Brar wrote:
> Introduce common framework for client/protocol drivers and
> controller drivers of Inter-Processor-Communication (IPC).
>
> Client driver developers should have a look at
>   include/linux/mailbox_client.h to understand the part of
> the API exposed to client drivers.
> Similarly controller driver developers should have a look
> at include/linux/mailbox_controller.h
>
> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
> ---
>   .../devicetree/bindings/mailbox/mailbox.txt        |  33 ++
>   Documentation/mailbox.txt                          | 107 +++++
>   MAINTAINERS                                        |   8 +
>   drivers/mailbox/Makefile                           |   4 +
>   drivers/mailbox/mailbox.c                          | 490 +++++++++++++++++++++
>   include/linux/mailbox_client.h                     |  48 ++
>   include/linux/mailbox_controller.h                 | 128 ++++++
>   7 files changed, 818 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/mailbox/mailbox.txt
>   create mode 100644 Documentation/mailbox.txt
>   create mode 100644 drivers/mailbox/mailbox.c
>   create mode 100644 include/linux/mailbox_client.h
>   create mode 100644 include/linux/mailbox_controller.h
>
> diff --git a/Documentation/devicetree/bindings/mailbox/mailbox.txt b/Documentation/devicetree/bindings/mailbox/mailbox.txt
> new file mode 100644
> index 0000000..3f00955
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mailbox/mailbox.txt
> @@ -0,0 +1,33 @@
> +* Generic Mailbox Controller and client driver bindings
> +
> +Generic binding to provide a way for Mailbox controller drivers to
> +assign appropriate mailbox channel to client drivers.
> +
> +* Mailbox Controller
> +
> +Required property:
> +- #mbox-cells: Must be at least 1. Number of cells in a mailbox
> +               specifier.
> +
> +Example:
> +       mailbox: mailbox {
> +               ...
> +               #mbox-cells = <1>;
> +       };
> +
> +
> +* Mailbox Client
> +
> +Required property:
> +- mbox: List of phandle and mailbox channel specifier.
> +
> +- mbox-names: List of identifier strings for each mailbox channel
> +               required by the client.
> +

IMO the mailbox names are more associated with the controller channels/
mailbox rather than the clients using it. Does it make sense to move
this under controller. It also avoid each client replicating the names.

Regards,
Sudeep

