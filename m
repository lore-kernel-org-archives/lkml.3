Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbaLKANe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 19:13:34 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:63087 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758312AbaLKANc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 19:13:32 -0500
MIME-Version: 1.0
In-Reply-To: <20141210223012.GA11234@shangw>
References: <1418160871-5605-1-git-send-email-yinghai@kernel.org>
	<20141210223012.GA11234@shangw>
Date: Wed, 10 Dec 2014 16:13:32 -0800
X-Google-Sender-Auth: FRBbc0hYP-I0KXJgYWUAVuY5UYw
Message-ID: <CAE9FiQVL01gj+mnRgyVzoc_MvkpDfoZ3zQat1-pOamoh4vg8ow@mail.gmail.com>
Subject: Re: [PATCH] PCI: Clear all bridge res MEM_64 if host bridge has non mem64
From: Yinghai Lu <yinghai@kernel.org>
To: Gavin Shan <gwshan@linux.vnet.ibm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?Q?Marek_Kord=C3=ADk?= <kordikmarek@gmail.com>,
        Alexey Voronkov <zermond@gmail.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 2:30 PM, Gavin Shan <gwshan@linux.vnet.ibm.com> wrote:
> On Tue, Dec 09, 2014 at 01:34:31PM -0800, Yinghai Lu wrote:
>>
>>+      list_for_each_entry(window, &bridge->windows, list) {
>>+              res = window->res;
>>+              if (resource_type(res) == IORESOURCE_MEM ||
>>+                  res->end > 0xffffffff) {
>
> Should we replace "||" with "&&" ?

oh, I missed that.

Will send updated version.

Thanks

Yinghai
