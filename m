Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab3ANMXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 07:23:06 -0500
Received: from smtp1.uu.se ([130.238.7.54]:48987 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464Ab3ANMXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 07:23:05 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20723.63603.114080.51605@pilspetsen.it.uu.se>
Date: Mon, 14 Jan 2013 13:22:11 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Schrober <franzschrober@yahoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: container-of Implementation
In-Reply-To: <1635127.Ytukyo95FQ@bentobox>
References: <1635127.Ytukyo95FQ@bentobox>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Schrober writes:
 > Hi,
 > 
 > I wondered why the container_of implementation is so complicated.
 > 
 > #define container_of(ptr, type, member) ({			\
 > 	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
 > 	(type *)( (char *)__mptr - offsetof(type,member) );})
 > 
 > isn't the __mptr not unnecessary? Why not following version?
 > 
 > #define container_of(ptr, type, member) \
 >     ((type *)((char *)(ptr) - offsetof(type, member)))

Compile-time type checking.  The first version requires ptr to be
assignment-compatible with the type of the struct member, the second
version accepts random junk for ptr.
