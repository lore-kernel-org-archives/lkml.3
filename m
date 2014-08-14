Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaHNSh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 14:37:56 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:35924 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbaHNShz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 14:37:55 -0400
MIME-Version: 1.0
In-Reply-To: <CACsCDOP8DOnB0zZtT_WLhiBXjxXh1aH1eGF9_h0dRN1i9YDU-A@mail.gmail.com>
References: <20140723113314.GA7798@chaz.gmail.com>
	<53CFCD26.1020409@infradead.org>
	<CACsCDOP8DOnB0zZtT_WLhiBXjxXh1aH1eGF9_h0dRN1i9YDU-A@mail.gmail.com>
Date: Thu, 14 Aug 2014 11:37:53 -0700
Message-ID: <CAHA+R7MLQtYF5vBN0D66Wk8iyGZABf5=Az293gUH6w=4THv8Gw@mail.gmail.com>
Subject: Re: network interfaces called "all", "default" or "config"
From: Cong Wang <cwang@twopensource.com>
To: Stephane Chazelas <stephane.chazelas@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 2:41 AM, Stephane Chazelas
<stephane.chazelas@gmail.com> wrote:
> By the way, this is related:
>
> $ ip link add link eth0 eth0:123 type vlan id 123
> $ ip link del link eth0 eth0:123
> RTNETLINK answers: Operation not supported

Kernel reads "eth0:123" as an alias of "eth0", so it will just
truncate the dev name into "eth0":


        ifr.ifr_name[IFNAMSIZ-1] = 0;

        colon = strchr(ifr.ifr_name, ':');
        if (colon)
                *colon = 0;
