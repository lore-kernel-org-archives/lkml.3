Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaFZS2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:28:00 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:28091 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862AbaFZS17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:27:59 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtkZABBlrFNXQz8N/2dsb2JhbABagw2CSYEAqAEBAQEBAQEFAW2YeQICAQEBgQwXdYQDAQEEATocIwULCAMYLjkeBhOIOgwBwjoXhWSJHAeEQwEEj3qKXgGLOog7g0Q7
Date: Thu, 26 Jun 2014 20:26:36 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Bob Copeland <me@bobcopeland.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] FS/OMFS: block number sanity check during
 fill_super operation
Message-Id: <20140626202636.7b601260c02ecc45c3c87316@skynet.be>
In-Reply-To: <CA+55aFwMNDegPgCD6AAKUUA-YCvViTp2nbwNkVojErrDkuFeUA@mail.gmail.com>
References: <1403802228-8385-1-git-send-email-fabf@skynet.be>
	<CA+55aFwMNDegPgCD6AAKUUA-YCvViTp2nbwNkVojErrDkuFeUA@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014 10:08:04 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Jun 26, 2014 10:05 AM, "Fabian Frederick" <fabf@skynet.be> wrote:
> >
> > +#define OMFS_MAX_BLOCKS (1 << 31)
> 
> This is wrong. Think about the types, and what value this has...
> 

Hello Linus,

   Sorry but I don't see a problem with 2^31 value.
It's being compared to u64 value then used in DIV_ROUND_UP: divided by 8 to fit in unsigned int (maximum 2^32 - 1)... What value should I use ?

Thanks,
Fabian

>      Linus
