Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbbAWQI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:08:56 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:58709 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbbAWQIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:08:54 -0500
Message-ID: <54C27214.9020003@gmail.com>
Date: Fri, 23 Jan 2015 11:08:52 -0500
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sun Paul <paulrbk@gmail.com>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Question on SCTP ABORT chunk is generated when the association_max_retrans
 is reached
References: <CAFXGftKp3=OfjkCVBuR-zM3+uZ42Sk_9i2UjAHBNnbX=hQJwpA@mail.gmail.com> <CAFXGft+fwo=8LJEG7h6uOpGciSo5f_dXjSx3sn67RZZp7jsYHw@mail.gmail.com>
In-Reply-To: <CAFXGft+fwo=8LJEG7h6uOpGciSo5f_dXjSx3sn67RZZp7jsYHw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 05:25 AM, Sun Paul wrote:
> Hi
> 
> I would like to check the behave in LKSCTP.
> 
> we are running DIAMETER message over SCTP, and we have set the
> parameter "net.sctp.association_max_retrans = 4" in the LinuxOS.
> 
> We noticed that when remote peer have retry to send the same request
> for 4 times, the LKSCTP will initiate an ABORT chunk with reason
> "association exceeded its max_retrans count".
> 
> We would like to know whether this is the correct behavior? is there
> any other option that we can alter in order to avoid the ABORT chunk
> being sent?
> 

Why do you not want ABORT to be sent? SCTP has attempted to retransmit
the data maximum allows times, and at this point it will terminate
the association.  It sends an ABORT notifying the peer of this, but
most likely the peer is unreachable anyway.

Any message that a peer sends at this point will most likely result
in an ABORT to be send back or an association restart.  Might
as well start fresh.

-vlad

> Thanks
> 
> PS
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

