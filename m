Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbaCQKjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:39:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348AbaCQKjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:39:21 -0400
Date: Mon, 17 Mar 2014 11:39:05 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 1/5] perf tests: Add tip/pid mmap automated tests
Message-ID: <20140317103905.GA6469@krava.brq.redhat.com>
References: <1394805606-25883-1-git-send-email-jolsa@redhat.com>
 <1394805606-25883-2-git-send-email-jolsa@redhat.com>
 <87iordtomz.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iordtomz.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 01:50:12PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Fri, 14 Mar 2014 15:00:02 +0100, Jiri Olsa wrote:
> > +static int thread_init(struct thread_data *td)
> > +{
> > +	void *map;
> > +
> > +	map = mmap(NULL, page_size, PROT_READ|PROT_WRITE,
> > +		   MAP_SHARED|MAP_ANONYMOUS, -1, 0);
> 
> Shouldn't it be an executable mapping to be found by MAP__FUNCTION?

yea.. looks like my arch implies PROT_EXEC via PROT_READ, man mmap:

  On some hardware architectures (e.g., i386), PROT_WRITE implies PROT_READ.   It  is  architecture  dependent  whether  PROT_READ
  implies PROT_EXEC or not.  Portable programs should always set PROT_EXEC if they intend to execute code in the new mapping.


mm/mmap.c:

        /*
         * Does the application expect PROT_READ to imply PROT_EXEC?
         *
         * (the exception is when the underlying filesystem is noexec
         *  mounted, in which case we dont add PROT_EXEC.)
         */
        if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
                if (!(file && (file->f_path.mnt->mnt_flags & MNT_NOEXEC)))
                        prot |= PROT_EXEC;


I'll set the PROT_EXEC as the man page says.


thanks,
jirka
