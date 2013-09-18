Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab3IRKV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:21:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16314 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3IRKVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:21:54 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-10-52397ec1f045
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 0/6] usb: s3c-hsotg: fixes for proper functioning
Date: Wed, 18 Sep 2013 12:21:29 +0200
Message-id: <1379499695-5279-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t9jAd2DdZZBBpd/81tsnLGe1eLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9ktHhzeye7A7rF/7hp2j74tqxg9jt/YzuTxeZNcAEsUl01K
	ak5mWWqRvl0CV8aJ7X2sBf+5K3ra3jA1MD7k7GLk5JAQMJF4fH4VO4QtJnHh3nq2LkYuDiGB
	RYwSr48tYIRw2pkkVk68xghSxSagI7Hl+wQwW0RAQGL9i0vsIEXMAtsZJZ787wJLCAu4SDQ9
	+8rUxcjBwSKgKvFqIxtImBcovO7GDXaQsISAgsScSTYTGLkXMDKsYhRNLUguKE5KzzXUK07M
	LS7NS9dLzs/dxAgOjGdSOxhXNlgcYhTgYFTi4b1QbhEkxJpYVlyZe4hRgoNZSYTXpcwySIg3
	JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVANjy4dnxl9NQ8O/
	asaGthmzaz790Gya/yFC/mFD1t9dvW7zL+dNCnluWLanQMuFXaB5f5vB95C7BTWt021/Xfy7
	LXYmh3OAzAzb7AlruI7xnHVQiWeqPfrycXMmG3/UOWXp577TmK9nTpxxKGRbePN+daZf794m
	lFeW7GBTytI7k/Zzrd+H9jAlluKMREMt5qLiRAAkdZfZCAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a second version of set of patches fixing s3c-hsotg USB driver
functioning. I've fixed issuses pointed by Felipe Balbi. For more information,
please check the change log at the end of the mail.

These patches add few fixes:
- Fix "protocol stall" handling, by enqueue new ep0 request when stalled
- Fix s3c_hsotg_write_fifo function to be usable in dedicated-fifo mode.
  Actually PTxFEmp/NPTxFEmp interrupts are enabled only in shared-fifo mode.
- Fix endpoint interrput handling, by disabling interrupts for endpoints which
  has no requests enqueued.
- Fixed DAINT register usage. Now only masked ep interrupts are handled.
- Fix "halt" property updating.
- Fix endpoint halt clearing, when it is not currently halted.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Changelog:

v2:
- splitted patches to get one fix in each patch, as Felipe Balbi suggested
- fixed typos

v1: https://lkml.org/lkml/2013/9/12/324
- initial proposal

Robert Baldyga (6):
  USB: gadget: s3c-hsotg: fix "protocol stall" handling
  USB: gadget: s3c-hsotg: fix s3c_hsotg_write_fifo function for
    dedicated fifo mode
  USB: gadget: s3c-hsotg: fix endpoint interrupts handling
  USB: gadget: s3c-hsotg: add DAINT masking
  USB: gadget: s3c-hsotg: fix "halted" property updating
  USB: gadget: s3c-hsotg: fix clear feature ENDPOINT_HALT

 drivers/usb/gadget/s3c-hsotg.c |   60 ++++++++++++++++++++++++++++++++--------
 1 file changed, 48 insertions(+), 12 deletions(-)

-- 
1.7.9.5

