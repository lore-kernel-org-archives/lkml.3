Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaG1NuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:50:18 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48097 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaG1NuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:50:16 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv9 4/4] dt: mailbox: add generic bindings
To: Jassi Brar <jaswinder.singh@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: ks.giri@samsung.com, arnd@arndb.de, ijc@hellion.org.uk,
        mark.rutland@arm.com, robh@kernel.org, pawel.moll@arm.com,
        courtney.cavin@sonymobile.com, mporter@linaro.org,
        slapdau@yahoo.com.au, lftan.linux@gmail.com, loic.pallardy@st.com,
        s-anna@ti.com, ashwin.chaugule@linaro.org, bjorn@kryo.se,
        patches@linaro.org, t.takinishi@jp.fujitsu.com, broonie@linaro.org,
        khilman@linaro.org, mollie.wu@linaro.org, andy.green@linaro.org,
        lee.jones@linaro.org, Jassi Brar <jaswinder.singh@linaro.org>
In-Reply-To: <1406055456-29384-1-git-send-email-jaswinder.singh@linaro.org>
References: <1406055250-29159-1-git-send-email-jaswinder.singh@linaro.org>
	<1406055456-29384-1-git-send-email-jaswinder.singh@linaro.org>
Date: Mon, 28 Jul 2014 07:50:08 -0600
Message-Id: <20140728135008.1E8C4C408A9@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014 00:27:36 +0530, Jassi Brar <jaswinder.singh@linaro.org> wrote:
> Define generic bindings for the framework clients to
> request mailbox channels.
> 
> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>

Looks okay to me.

g.

> ---
>  .../devicetree/bindings/mailbox/mailbox.txt        | 36 ++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mailbox/mailbox.txt
> 
> diff --git a/Documentation/devicetree/bindings/mailbox/mailbox.txt b/Documentation/devicetree/bindings/mailbox/mailbox.txt
> new file mode 100644
> index 0000000..bb79678
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mailbox/mailbox.txt
> @@ -0,0 +1,36 @@
> +* Generic Mailbox Controller and client driver bindings
> +
> +Generic binding to provide a way for Mailbox controller drivers to
> +assign appropriate mailbox channel to client drivers.
> +
> +* Mailbox Controller
> +
> +Required property:
> +- #mbox-cells: Must be at least 1. Number of cells in a mailbox
> +		specifier.
> +
> +Example:
> +	mailbox: mailbox {
> +		...
> +		#mbox-cells = <1>;
> +	};
> +
> +
> +* Mailbox Client
> +
> +Required property:
> +- mboxes: List of phandle and mailbox channel specifiers.
> +
> +Optional property:
> +- mbox-names: List of identifier strings for each mailbox channel
> +		required by the client. The use of this property
> +		is discouraged in favor of using index in list of
> +		'mboxes' while requesting a mailbox.
> +
> +Example:
> +	pwr_cntrl: power {
> +		...
> +		mbox-names = "pwr-ctrl", "rpc";
> +		mboxes = <&mailbox 0
> +			&mailbox 1>;
> +	};
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

