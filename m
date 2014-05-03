Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaECV6x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 17:58:53 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49460 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972AbaECV6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 17:58:52 -0400
Message-ID: <1399154328.2505.29.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 0/2] namespaces: log namespaces per task
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, serge.hallyn@ubuntu.com,
        eparis@redhat.com, sgrubb@redhat.com, ebiederm@xmission.com
Date: Sat, 03 May 2014 14:58:48 -0700
In-Reply-To: <cover.1398176489.git.rgb@redhat.com>
References: <cover.1398176489.git.rgb@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-22 at 14:12 -0400, Richard Guy Briggs wrote:
> Questions:
> Is there a way to link serial numbers of namespaces involved in migration of a
> container to another kernel?  (I had a brief look at CRIU.)  Is there a unique
> identifier for each running instance of a kernel?  Or at least some identifier
> within the container migration realm?

Are you asking for a way of distinguishing an migrated container from an
unmigrated one?  The answer is pretty much "no" because the job of
migration is to restore to the same state as much as possible.

Reading between the lines, I think your goal is to correlate audit
information across a container migration, right?  Ideally the management
system should be able to cough up an audit trail for a container
wherever it's running and however many times it's been migrated?

In that case, I think your idea of a numeric serial number in a dense
range is wrong.  Because the range is dense you're obviously never going
to be able to use the same serial number across a migration.  However,
if you look at all the management systems for containers, they all have
a concept of some unique ID per container, be it name, UUID or even
GUID.  I suspect it's that you should be using to tag the audit trail
with.

James


