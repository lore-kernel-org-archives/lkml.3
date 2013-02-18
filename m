Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab3BRRHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:07:33 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:57594 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755057Ab3BRRHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:07:31 -0500
Date: Mon, 18 Feb 2013 09:07:31 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, pv-drivers@vmware.com
Message-ID: <1398469748.2079082.1361207251021.JavaMail.root@vmware.com>
In-Reply-To: <511CC511.7080902@redhat.com>
References: <1360196636-9357-1-git-send-email-acking@vmware.com> <1360196636-9357-2-git-send-email-acking@vmware.com> <511CC511.7080902@redhat.com>
Subject: Re: [PATCH 1/1] VSOCK: Introduce VM Sockets
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.163.67]
X-Mailer: Zimbra 8.0.2_GA_5569 (ZimbraWebClient - GC24 (Mac)/8.0.2_GA_5569)
Thread-Topic: VSOCK: Introduce VM Sockets
Thread-Index: mPu1EeF8XrgD3mX7DWOH8uOWpSnhiA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerd,

> > +		written = transport->stream_enqueue(
> > +				vsk, msg->msg_iov,
> > +				len - total_written);
> 
> Hmm, shouldn't we pass total_written to stream_enqueue here?
> 
> In case a blocking send(big-buffer) call gets splitted into multiple
> stream_enqueue calls the second (and further) stream_enqueue calls need
> to know at which msg offset they should continue sending the data, no?

On the client side, the iov tracks it internally; see memcpy_fromiovec().
On the socket side, VMCI uses a ring buffer, so it also knows its
position internally.  Or did I misunderstand the question?

Thanks!
- Andy
