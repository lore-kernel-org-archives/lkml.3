Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287AbaFJH2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 03:28:41 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:59655 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933692AbaFJH2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 03:28:40 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] perf timechart: implement IO mode
References: <1402305672-2630-1-git-send-email-stfomichev@yandex-team.ru>
	<1402305672-2630-3-git-send-email-stfomichev@yandex-team.ru>
Date: Tue, 10 Jun 2014 16:28:37 +0900
In-Reply-To: <1402305672-2630-3-git-send-email-stfomichev@yandex-team.ru>
	(Stanislav Fomichev's message of "Mon, 9 Jun 2014 13:21:12 +0400")
Message-ID: <877g4pb4uy.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Jun 2014 13:21:12 +0400, Stanislav Fomichev wrote:
> In IO mode timechart shows any disk/network activity.

It breaks build like below:

    CC       util/svghelper.o
  util/svghelper.c: In function ‘svg_ubox’:
  util/svghelper.c:154:91: error: declaration of ‘error’ shadows a global declaration [-Werror=shadow]
  In file included from util/svghelper.c:24:0:
  util/util.h:137:12: error: shadowed declaration is here [-Werror=shadow]
  util/svghelper.c: In function ‘svg_lbox’:
  util/svghelper.c:173:91: error: declaration of ‘error’ shadows a global declaration [-Werror=shadow]
  In file included from util/svghelper.c:24:0:
  util/util.h:137:12: error: shadowed declaration is here [-Werror=shadow]
  util/svghelper.c: In function ‘svg_fbox’:
  util/svghelper.c:192:91: error: declaration of ‘error’ shadows a global declaration [-Werror=shadow]
  In file included from util/svghelper.c:24:0:
  util/util.h:137:12: error: shadowed declaration is here [-Werror=shadow]
  cc1: all warnings being treated as errors
  make[1]: *** [util/svghelper.o] Error 1


Thanks,
Namhyung
