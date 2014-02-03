Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaBCX7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:59:43 -0500
Received: from forward11.mail.yandex.net ([95.108.130.93]:36101 "EHLO
	forward11.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaBCX7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:59:42 -0500
From: "zbr@ioremap.net" <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: David Fries <david@fries.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1391390104-31154-1-git-send-email-David@Fries.net>
References: <1391390104-31154-1-git-send-email-David@Fries.net>
Subject: Re: [PATCH 0/4] w1: refcnt fix, skip non-error send, docs
MIME-Version: 1.0
Message-Id: <9071391471978@web15j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 04 Feb 2014 03:59:38 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

03.02.2014, 05:15, "David Fries" <David@Fries.net>:

> šI could submit these patches as in, which would require the previous
> šset, or I could merge the documentation into the previous set and
> šresubmit them all since they haven't made it into the kernel tree yet.
> šOpinions?
>
> šHere's a small refcnt fix, skipping sending non-error messages, and
> šdocumentation and comment updates.
>
> šnon-error error messages:
> šCurrently every master or slave command is sending a response with
> šw1_netlink_send_error no matter if there is an error or not. šThis
> šmakes commands like list slaves W1_CMD_LIST_SLAVES or W1_CMD_READ
> šreturn two messages, one with data and one without. šThat is a problem
> šwith the list slaves because they are identical except for one having
> šdata and one not, and since there could be no slaves known to the
> škernel you can't just discard the no data case, unless the program
> šwere to expect two replies. šSo I propose only sending the error reply
> šif there is an error, in which case there wouldn't be a normal reply
> š(such as read). šThis would mean commands like write would no longer
> šreturn a response unless there was an error. šIf an application wanted
> što verify the kernel received the write message it could follow it by
> ša read to verify the data or just that read came after write and had a
> šresponse so write must have completed without error. šI think it is
> šsafe to do away with the extra replies. šIf someone sees a big enough
> šneed for this, I could modify it so all commands return one response,
> šwith commands like write always calling send error even if there
> šwasn't one.

I created this protocol to handle cases like nothing is returned, but yet userspace knows
operations has been completed. Also, you can not really change it at this time - there are
already userspace application which may depend on the last ack to find out its request completed.

Reference counter fix is correct, please submit it in the separate patch.
