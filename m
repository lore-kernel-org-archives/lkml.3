Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278Ab3BNLGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 06:06:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab3BNLGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 06:06:05 -0500
Message-ID: <511CC511.7080902@redhat.com>
Date: Thu, 14 Feb 2013 12:05:53 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Andy King <acking@vmware.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, pv-drivers@vmware.com
Subject: Re: [PATCH 1/1] VSOCK: Introduce VM Sockets
References: <1360196636-9357-1-git-send-email-acking@vmware.com> <1360196636-9357-2-git-send-email-acking@vmware.com>
In-Reply-To: <1360196636-9357-2-git-send-email-acking@vmware.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/13 01:23, Andy King wrote:
> +		written = transport->stream_enqueue(
> +				vsk, msg->msg_iov,
> +				len - total_written);

Hmm, shouldn't we pass total_written to stream_enqueue here?

In case a blocking send(big-buffer) call gets splitted into multiple
stream_enqueue calls the second (and further) stream_enqueue calls need
to know at which msg offset they should continue sending the data, no?

cheers,
  Gerd
