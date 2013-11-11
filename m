Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab3KKNzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:55:21 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:64995 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3KKNzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:55:15 -0500
MIME-Version: 1.0
Date: Mon, 11 Nov 2013 19:25:14 +0530
Message-ID: <CAP8BHkGZ5EFxW4BNervKrOiEaQTNdSh9s2YOrFoexzQCOR=AqQ@mail.gmail.com>
Subject: IPv6: Blackhole route support partial ?
From: Kamala R <kamala@aristanetworks.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On adding IPv6 blackhole routes, ICMP unreachable messages are being
sent back to source. According to the definition, packets destined to
a blackhole address must be dropped silently.


I applied the patch submitted to the 3.7 kernel that indicates that it
supports blackhole and prohibit routes correctly. However, the patch
only sets the error code and route type correctly, so the show command
displays the appropriate output.


It seems to me that the input and output function pointers of the dst
variable, which determine packet processing, need to be set to
dst_discard. This would enable correct behaviour for blackhole routes.
Am I on the right path here ?

Thanks and Regards,
Kamala
