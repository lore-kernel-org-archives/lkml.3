Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaLRFEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 00:04:44 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:37372 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaLRFEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 00:04:43 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Thu, 18 Dec 2014 14:04:59 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tools lib traceevent: Add support for IP address formats
Message-ID: <20141218050459.GD20215@sejong>
References: <1418848148-35919-1-git-send-email-dsahern@gmail.com>
 <20141218042632.GB20215@sejong>
 <549258DB.1010408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <549258DB.1010408@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 09:32:27PM -0700, David Ahern wrote:
> On 12/17/14 9:26 PM, Namhyung Kim wrote:
> >
> >It'd be better if we do it like below..
> >
> >	char i = *ptr++;
> >
> >Why not passing ptr + 1 to print_ip_arg()?
> >
> 
> That parsing loop is a bit weird - and deep. And I only wanted to consume
> 'pi' and 'pI' with parse_ip_arg if and only if the next letters are '4', '6'
> and 'S'.

Yeah, I know - but I still think you can pass ptr + 1 (but not update
ptr) since everytime you only access to ptr + 1 unless I missed it.
Consuming ptr depends on the return value so it's irrelevant whether
you pass ptr or (ptr + 1) IMHO.

Thanks,
Namhyung
