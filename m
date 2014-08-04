Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaHDRIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:08:21 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:45529 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaHDRIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:08:19 -0400
MIME-Version: 1.0
From: Pranith Kumar <pranith@gatech.edu>
Date: Mon, 4 Aug 2014 13:07:47 -0400
X-Google-Sender-Auth: SaOmkyQyHze-IW03G98WgtiN9wU
Message-ID: <CAJhHMCADiEsUC7GsYF7=qMNEyRJerfhC5zh7WQPgkQ0gJn5=5A@mail.gmail.com>
Subject: Question regarding "Control Dependencies" in memory-barriers.txt
To: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The section "Control Dependencies" in memory-barriers.txt has the
following text:

662 In addition, you need to be careful what you do with the local variable 'q',
663 otherwise the compiler might be able to guess the value and again remove
664 the needed conditional.  For example:
665
666         q = ACCESS_ONCE(a);
667         if (q % MAX) {
668                 barrier();
669                 ACCESS_ONCE(b) = p;
670                 do_something();
671         } else {
672                 barrier();
673                 ACCESS_ONCE(b) = p;
674                 do_something_else();
675         }
676
677 If MAX is defined to be 1, then the compiler knows that (q % MAX) is
678 equal to zero, in which case the compiler is within its rights to
679 transform the above code into the following:
680
681         q = ACCESS_ONCE(a);
682         ACCESS_ONCE(b) = p;
683         do_something_else();

Given that there is an explicit barrier() in both the branches of
if/else statement, how can the above transformation happen? The
compiler cannot just remove the barrier(), right?

I think it will transform to the following if MAX is defined to 1:

q = ACCESS_ONCE(a);
barrier();
ACCESS_ONCE(b) = p;
do_something_else();

and hence the ordering will be preserved. What am I missing here?

-- 
Pranith
