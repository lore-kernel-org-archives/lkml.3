Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbbALJHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:07:42 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:52281 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbALJHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:07:39 -0500
MIME-Version: 1.0
Date: Mon, 12 Jan 2015 13:07:38 +0400
Message-ID: <CAFwitOHnMOeyc9-pXZPp4DThGr=nc47fmWHBgA6X2fDbFomjvg@mail.gmail.com>
Subject: Re: [PATCH] Cleanup: snprintf() always NUL-terminates: depend on it
From: Aleksandr P <alexpikptz@gmail.com>
To: me@mortis.eu
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   len = snprintf(fname, 99, "%s", buf);
> - fname[len-1] = '\0';

> I just deleted that "really, really" NUL-termination line because
> it was based on a misunderstanding of snprintf()'s postcondition.

Are you sure this code can be simple deleted? It does not only
terminate the string but deletes the last character. According to man:
" Upon successful return, these functions return the number of
characters printed (EXCLUDING the null  byte  used  to end output to
strings)."
So, if buf was "abc" len would be 3 and fname would become "ab".

Best regards,
Alexandr
