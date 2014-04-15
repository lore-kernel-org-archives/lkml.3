Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaDOPkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:40:40 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44976 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaDOPkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:40:37 -0400
Date: Tue, 15 Apr 2014 16:40:29 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Emmanuel Colbus <ecolbus@manux.info>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][5/11][MANUX] Kernel compatibility : major/minor numbers
Message-ID: <20140415164029.69196976@alan.etchedpixels.co.uk>
In-Reply-To: <534D5119.8050701@manux.info>
References: <534D3762.4010905@manux.info>
	<20140415160626.322e24ee@alan.etchedpixels.co.uk>
	<534D5119.8050701@manux.info>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why is it? I mean, as far as userspace is concerned, they do have a
> unique identifier : their name. How would it be problematic that the

No - a name is never a unique identifier in a Unix system. The
fundamental object is the file handle. If I want to be able to answer the
question

"are these two file handles pointing to the same device"

I need the major/minor to do so. Even if I know the name I don't know if
two opens of the same name produced references to the same object,
because another process may have changed it under me.

Most code doesn't care. You can happily replace /dev/null with something
else (or accidentally make it a file and then a year later wonder why
your disk is full).

Names are very much second class citizens. An object can have a file
handle without a name, or with many names

Alan
