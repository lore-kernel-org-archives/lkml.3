Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaJATQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:16:33 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:62526 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaJATQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:16:31 -0400
MIME-Version: 1.0
Date: Wed, 1 Oct 2014 21:16:31 +0200
Message-ID: <CABPqkBQPjpgD_5n0ZMmx971+YO86CO+5mSfcg7a1p4Ys_TgOUA@mail.gmail.com>
Subject: [BUG] perf tools: off-by-one error in map_groups__find_ams()
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It appears that there is a off-by-one bug in map_groups__find_ams().
The upper-bound check in the test below should be >= because
end = start + len; The end address is outside the range.

Please confirm.


int map_groups__find_ams(struct addr_map_symbol *ams, symbol_filter_t filter)
{
                if (ams->addr < ams->map->start || ams->addr > ams->map->end) {
