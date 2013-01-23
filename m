Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3AWOfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:35:54 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35899 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab3AWOfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:35:53 -0500
Date: Wed, 23 Jan 2013 14:35:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: snakky.zhang@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is this a bug that n_tty_set_room not serialized? If so please
 correct it.
Message-ID: <20130123143541.0abfa379@www.etchedpixels.co.uk>
In-Reply-To: <50FF69C6.2040705@gmail.com>
References: <50FF69C6.2040705@gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2013 12:40:38 +0800
snakky.zhang@gmail.com wrote:

> Hi experts,
> 
> Seems there is an bug related to function n_tty_set_roomin source file
> drivers/tty/n_tty.c. This function is used to set receive_room based on
> the read_cntby both the consumer and the producer of the tty's read buffer.
> 
> But this function is not serialized, so I am afraid there is
> a risk like: The producer make the buffer full and then call this 
> function to

It's not entirely robust - it should be ok for current usage. The proper
fix IMHO is to make the ldisc receive function return the number of bytes
actually consumed. That cures the problem rather than patching around it.

It's an interesting little project for someone, and as I think only n_tty
uses that level of flow control probably not too horrible now.

Alan
