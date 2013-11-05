Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab3KEX6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:58:54 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:63864 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab3KEX6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:58:53 -0500
Message-ID: <52798635.70209@gmail.com>
Date: Tue, 05 Nov 2013 16:58:45 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: perf version not set when building out of tree
References: <5272E86B.7090003@gmail.com> <20131101070219.GA21471@gmail.com>
In-Reply-To: <20131101070219.GA21471@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/1/13, 1:02 AM, Ingo Molnar wrote:
> I think we should pack the PERF-VERSION-FILE with the tarball and
> use that. This needs roughly 3 changes:
>
>   - make PERF-VERSION-FILE part of the tarball
>   - make sure it's not zapped on 'make clean'
>   - don't try to regenerate it if there's no git repository to get a version from

Solution was actually kind of easy. The head commit is already saved to 
HEAD file when the tar is generated:

diff --git a/perf/tools/perf/util/PERF-VERSION-GEN 
b/perf/tools/perf/util/PERF-VERSION-GEN
index 15a77b7c0e36..2155882e7c1d 100755
--- a/perf/tools/perf/util/PERF-VERSION-GEN
+++ b/perf/tools/perf/util/PERF-VERSION-GEN
@@ -19,6 +19,9 @@ if test -d ../../.git -o -f ../../.git
  then
     TAG=$(git describe --abbrev=0 --match "v[0-9].[0-9]*" 2>/dev/null )
     CID=$(git log -1 --abbrev=4 --pretty=format:"%h" 2>/dev/null) && 
CID="-g$CID"
+elif test -f ../../HEAD
+then
+   TAG=$(cat ../../HEAD)
  fi
  if test -z "$TAG"
  then

David
