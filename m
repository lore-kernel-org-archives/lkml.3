Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbaDBIb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:31:28 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:38068 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478AbaDBIbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:31:25 -0400
MIME-Version: 1.0
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 2 Apr 2014 08:31:04 +0000
X-Google-Sender-Auth: jpSf2IXRlYIhsf7lKuDGVR5m1Ew
Message-ID: <CAM9d7ch-ZBYRHmhbHJEXQtS-V_kBPK5nMhtM3bPbHmnY+m-EeQ@mail.gmail.com>
Subject: About 'hash' event trigger patchset
To: Tom Zanussi <tom.zanussi@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

(Sorry for replying in another thread, I have a problem on mail settings)

I've just read your hash event trigger series, and want to give some feedback.

At first, the change log of 5/5 is actually a better documentation
than in patch 4/5 so I think it should be added to the doc also.  But
the syntax of the hash trigger should be look like:

- # echo hash:key(s):value(s)[:sort_keys()][ if filter] > event/trigger
+ # echo hash:key(s):value(s)[:"sort="sort_key(s)][ if filter] > event/trigger

Also on first example in the changelog of 5/5, key should be
'stacktrace' instead of 'call_site'.

As far as I see in the code, the sort key can receive an optional
descending/ascending modifier, but it's not documented.

One thing I noticed in the main logic is that it seems there's no
limit checking when adding/creating new entry.  In
hash_trigger_entry_create(), there's a check against max_entries but
if it goes beyond the max, it'd just access a NULL pointer AFAICS.  Am
I missing something?  Also I don't know what the difference between
->n_entries and ->total_entries (in hash_data).

I guess you wanted to set ->drops in that case, but I cannot find
where it gets set.  And I'm not sure it's good to check ->drop first,
since entry can find an existing entry and merged to it even if it
reached the max already.

Thanks,
Namhyung
