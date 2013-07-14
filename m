Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3GNKkK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 06:40:10 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35390 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab3GNKkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 06:40:08 -0400
MIME-Version: 1.0
Date: Sun, 14 Jul 2013 13:40:08 +0300
Message-ID: <CAMw0szJo2kBZZRC3yFAH3raonAC1h=rM8w-7KwWJnHutuxCHWA@mail.gmail.com>
Subject: Get index of address from netlink when network interface aliases are active
From: =?KOI8-R?B?4c7E0sXKIOHMwcTYxdc=?= <aladjev.andrew@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steps:
1. create some network aliases. ifconfig command returns list
eth0
eth0:0
eth0:1
lo
2. create AF_NETLINK socket and send RTM_GETADDR message to it
3. received events:
RTM_NEWADDR
  IFA_LABEL : "lo"
  ifa_index     : 0
RTM_NEWADDR
  IFA_LABEL : "eth0"
  ifa_index     : 1
RTM_NEWADDR
  IFA_LABEL : "eth0:0"
  ifa_index     : 1
RTM_NEWADDR
  IFA_LABEL : "eth0:1"
  ifa_index     : 1
4. delete network alias "eth0:1", than "eth0:0"
5. received events
RTM_DELADDR
  IFA_LABEL : "eth0:1"
  ifa_index     : 1
RTM_DELADDR
  IFA_LABEL : "eth0:0"
  ifa_index     : 1

Is there a way to get right address index? I want to make one-to-one
correspondence between address and data pointer. Without right address
index I cant use simple dynamic array. I have to perform event's
address hashing and use hash table or tree.

Thank you.
