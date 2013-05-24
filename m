Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab3EXXek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 19:34:40 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:37250 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab3EXXeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 19:34:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6pT2iTMx6U50AeScCjmPu53MOj6-TCnATRj_+EUNz46w@mail.gmail.com>
References: <519dcfbe.89e9420a.4934.488bSMTPIN_ADDED_BROKEN@mx.google.com>
	<1369329099-8501-1-git-send-email-yinghai@kernel.org>
	<CAErSpo6pT2iTMx6U50AeScCjmPu53MOj6-TCnATRj_+EUNz46w@mail.gmail.com>
Date: Fri, 24 May 2013 16:34:36 -0700
X-Google-Sender-Auth: i1pyCoUFnXQf3BCrVIT328_AawY
Message-ID: <CAE9FiQUV9GtMv7JxLb+r1g9nFw-ydXeaQFUOOzuAFn8xRjTbgA@mail.gmail.com>
Subject: Re: [PATCH] PCI: Don't let mmio fallback to must-only, if ioport
 fails with must+optional
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 10:25 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> The problem we're trying to solve is that when allocation for type X
> fails, we retry allocation for type Y.
>
> This patch handles IO specially.  I think it basically says, "if we
> only have IO allocation failures, don't retry MEM allocation."  But a
> clean strategy would also avoid retrying IO allocation if we only had
> MEM allocation failures.

Well, that will make it little bit complicated as v3 that is sent in
another mail.

Need to separate ioport, mmio, mmio pref three types.

Yinghai
