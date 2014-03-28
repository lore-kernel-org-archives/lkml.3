Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaC1WI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 18:08:56 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:60774 "HELO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751132AbaC1WIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 18:08:40 -0400
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Mar 2014 18:08:40 EDT
MIME-Version: 1.0
In-Reply-To: <1395957398-24546-1-git-send-email-asuka.com@163.com>
References: <1395957398-24546-1-git-send-email-asuka.com@163.com>
From: Jesse Gross <jesse@nicira.com>
Date: Fri, 28 Mar 2014 15:02:25 -0700
Message-ID: <CAEP_g=_qJ1uHKZmZdkUrT+NUkzbRgaHfShZoMbnnCb+LwjOneQ@mail.gmail.com>
Subject: Re: [PATCH] openvswitch: supply a dummy err_handler of
 gre_cisco_protocol to prevent kernel crash
To: Wei Zhang <asuka.com@163.com>
Cc: David Miller <davem@davemloft.net>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 2:56 PM, Wei Zhang <asuka.com@163.com> wrote:
> diff --git a/net/openvswitch/vport-gre.c b/net/openvswitch/vport-gre.c
> index a3d6951..d64c639 100644
> --- a/net/openvswitch/vport-gre.c
> +++ b/net/openvswitch/vport-gre.c
> @@ -110,6 +110,12 @@ static int gre_rcv(struct sk_buff *skb,
>         return PACKET_RCVD;
>  }
>
> +static int gre_dummy_err(struct sk_buff *skb, u32 info,
> +                        const struct tnl_ptk_info *tpi)
> +{
> +       return PACKET_REJECT;
> +}

I'm not sure that rejecting all ICMP packets is the correct thing do
here since it means that we could pass them onto a later caller even
though they are intended for us. We should probably use the same logic
as for receiving packets and just discard them here.
