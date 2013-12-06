Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232Ab3LFVFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:05:30 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47393 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3LFVF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:05:28 -0500
Message-ID: <52A23BDA.9000303@oracle.com>
Date: Fri, 06 Dec 2013 16:04:26 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: samuel@sortiz.org, "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: net: irda: hang when doing anything to a socket in accept()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've noticed that once an IRDA socket is in accept(), any further action that requires locking the
socket will result in a hang until accept() is completed (which may take a while). After a while
hung task spew is printed out.

		thread 1		|		thread 2
					|
	listen(sock)			|	
		bind(sock)		|
			accept(sock)	|
					|	setsockopt(sock)
						*HANG*	

I'm not sure I can provide a properly tested fix since I don't actually have IRDA hardware to test
on.


Thanks,
Sasha
