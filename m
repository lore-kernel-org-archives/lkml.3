Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3FCIu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:50:58 -0400
Received: from intranet.asianux.com ([58.214.24.6]:63520 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3FCIuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:50:55 -0400
X-Spam-Score: -100.8
Message-ID: <51AC58BB.20305@asianux.com>
Date: Mon, 03 Jun 2013 16:50:03 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Greg KH <gregkh@linuxfoundation.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: parisc: kernel: using strlcpy() instead of strcpy()
References: <51A6A8F3.2030200@asianux.com> <20130530150636.GA2121@udknight>
In-Reply-To: <20130530150636.GA2121@udknight>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 11:06 PM, Wang YanQing wrote:
> What about add 
> boot_command_line[COMMAND_LINE_SIZE - 1] = '\0';
> to protect the following another strcpy?
> 
> "
> strcpy(command_line, boot_command_line);
> "

If the 'dest' length is not less than COMMAND_LINE_SIZE, the strlcpy()
will copy 'COMMAND_LINE_SIZE - 1' contents, and always set '\0' in the end.

So the next strcpy() will be safe.


Thanks.
-- 
Chen Gang

Asianux Corporation
