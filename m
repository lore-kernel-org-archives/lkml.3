Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbaIQVVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:21:39 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:60520 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213AbaIQVVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:21:38 -0400
MIME-Version: 1.0
X-Originating-IP: [88.96.238.14]
In-Reply-To: <1807144344.40128259.1410985683342.JavaMail.zimbra@redhat.com>
References: <371358190.34795877.1410204429882.JavaMail.zimbra@redhat.com>
	<1444809468.34812041.1410206680931.JavaMail.zimbra@redhat.com>
	<20140909170231.GA14429@logfs.org>
	<1807144344.40128259.1410985683342.JavaMail.zimbra@redhat.com>
Date: Wed, 17 Sep 2014 22:21:37 +0100
Message-ID: <CAAEAJfDAG8KrPKqVC5NujGnbSyxmrAtFcLvhScYsNm8RT59Gnw@mail.gmail.com>
Subject: Re: [PATCH V2] mtd: block2mtd: Present block2mtd timely on boot time
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Rodrigo Freire <rfreire@redhat.com>
Cc: =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Felix Fietkau <nbd@openwrt.org>, David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Herton Krzesinski <hkrzesin@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 September 2014 21:28, Rodrigo Freire <rfreire@redhat.com> wrote:
>
> mtd: block2mtd: Ensure that block2mtd is presented in a timely fashion
>

Using block2mtd sounds a bit unusual. I see that you are trying to get
a more robust fs.... have you tried using f2fs instead of jffs2?

> Currently, a block MTD device is not presented to the system on time, in
> order to start mounting the filesystems. This patch ensures that block2mtd
> is presented at the right time, so filesystems can be mounted on boot time.

It worries me a bit to add such a long delay to the boot. If for some
reason the SD is not working, then the kernel will wait (by default) 3
seconds now?
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
