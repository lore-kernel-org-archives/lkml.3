Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaFJRNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:13:40 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:53825 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaFJRNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:13:38 -0400
Date: Tue, 10 Jun 2014 10:13:34 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Milos Vyletel <milos.vyletel@gmail.com>
Cc: davem@davemloft.net, amwang@redhat.com, netdev@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Pravin B Shelar <pshelar@nicira.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Mike Rapoport <mike.rapoport@ravellosystems.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>, Tom Herbert <therbert@google.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Florent Fourcot <florent.fourcot@enst-bretagne.fr>,
        Eric Dumazet <edumazet@google.com>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        linux-usb@vger.kernel.org (open list:USB CDC ETHERNET...),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [patch net-next 3/5] ipv6: consider net.ipv6.conf.all sysctls
 when making decisions
Message-ID: <20140610101334.565bc484@nehalam.linuxnetplumber.net>
In-Reply-To: <1402417153-2551-4-git-send-email-milos.vyletel@gmail.com>
References: <1402417153-2551-1-git-send-email-milos.vyletel@gmail.com>
	<1402417153-2551-4-git-send-email-milos.vyletel@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014 12:19:11 -0400
Milos Vyletel <milos.vyletel@gmail.com> wrote:

> As it is right now net.ipv6.conf.all.* are mostly ignored and instead
> we're only making decisions based on interface specific settings. These
> settings are coppied from net.ipv6.conf.default and changing either all
> or default settings have no effect.

Although this is the right idea conceptually, it risks creating unhappy
users because it changes the semantics of the API. This will probably break
somebody's configuration.
